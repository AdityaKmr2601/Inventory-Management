create database if not exists inventory_management;
use inventory_management;

create table if not exists users(
    user_id int auto_increment primary key,
    username varchar(50) not null,
    password varchar(255) not null,
    role enum('admin', 'manager', 'logistics') not null
);

create table if not exists products (
    product_id int auto_increment primary key,
    product_name varchar(100) not null,
    stock int not null default 0
);

create table if not exists orders (
    order_id int auto_increment primary key,
    product_id int not null,
    ordered_quantity int not null,
    status enum('pending', 'delivered') default 'pending',
    order_date timestamp default current_timestamp,
    delivery_date timestamp null,
    foreign key(product_id) references products(product_id)
);

create table if not exists order_log (
    log_id int auto_increment primary key,
    order_id int not null,
    product_id int not null,
    initial_stock int not null,
    ordered_quantity int not null,
    remaining_stock int not null,
    log_date timestamp default current_timestamp,
    foreign key(order_id) references orders(order_id),
    foreign key(product_id) references products(product_id)
);

insert into users (username, password, role) values
('admin1', 'admin_password_hash', 'admin'),
('manager1', 'manager_password_hash', 'manager'),
('logistics1', 'logistics_password_hash', 'logistics');

insert into products (product_name, stock) values
('Product A', 100),
('Product B', 200);


start transaction;

insert into orders (product_id, ordered_quantity) 
values (1, 30);

select stock into @current_stock from products where product_id = 1;

set @remaining_stock = @current_stock - 30;

update products set stock = @remaining_stock where product_id = 1;

insert into order_log (order_id, product_id, initial_stock, ordered_quantity, remaining_stock)
values (last_insert_id(), 1, @current_stock, 30, @remaining_stock);

commit;

update orders set status = 'delivered', delivery_date = now() where product_id = 1;

select * from products;
select * from orders;
select * from order_log;

