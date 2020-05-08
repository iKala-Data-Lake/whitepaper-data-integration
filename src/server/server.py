#! /bin/env python3

import os

import mysql.connector
from flask import Flask, g, jsonify, make_response
from pymongo import MongoClient

app = Flask(__name__)


@app.before_first_request
def init_connection():
    g.mysql_db = mysql.connector.connect(
        host=os.getenv('MYSQL_CONTAINER_NAME', 'localhost'),
        database='example',
        user=os.getenv('MYSQL_USERNAME', 'root'),
        password=os.getenv('MYSQL_PASSWORD', '12345678'),
        pool_size=10,
    )
    g.mongo_db = MongoClient('mongodb://{user}:{password}@{host}:27017/'.format(
        host=os.getenv('MONGODB_CONTAINER_NAME', 'localhost'),
        user=os.getenv('MONGO_USERNAME', 'mongo'),
        password=os.getenv('MONGO_PASSWORD', '12345678'),
    ))


def get_mysql():
    if 'mysql_db' not in g:
        g.mysql_db = mysql.connector.connect(
            host=os.getenv('MYSQL_CONTAINER_NAME', 'localhost'),
            database='example',
            user=os.getenv('MYSQL_USERNAME', 'root'),
            password=os.getenv('MYSQL_PASSWORD', '12345678'),
            pool_size=10,
        )
    return g.mysql_db


def get_mongo():
    if 'mongo_db' not in g:
        g.mongo_db = MongoClient('mongodb://{user}:{password}@{host}:27017/'.format(
            host=os.getenv('MONGODB_CONTAINER_NAME', 'localhost'),
            user=os.getenv('MONGO_USERNAME', 'mongo'),
            password=os.getenv('MONGO_PASSWORD', '12345678'),
        ))
    return g.mongo_db


def close_db(e=None):
    mysql_db = g.pop('mysql_db', None)
    if mysql_db is not None:
        mysql_db.close()

    mongo_db = g.pop('mongo_db', None)
    if mongo_db is not None:
        mongo_db.close()


@app.route('/api/users/', methods=['GET'])
def list_users():
    try:
        connection = get_mysql()
        cursor = connection.cursor()
        cursor.execute('SELECT user_id FROM users;')

        response = {
            'users': [
                {'id': user_id}
                for (user_id,) in cursor
            ],
            'total': cursor.rowcount,
        }
        return jsonify(response)
    finally:
        connection.close()


@app.route('/api/users/<string:user_id>', methods=['GET'])
def get_user(user_id):
    try:
        connection = get_mysql()
        cursor = connection.cursor()
        cursor.execute(
            '''
            SELECT user_id, username, full_name, address, email, phone 
            FROM users WHERE user_id=%s;
            ''',
            (user_id,)
        )

        result = cursor.fetchall()
        if len(result) > 0:
            (user_id, username, full_name, address, email, phone) = result[0]
            return jsonify({
                "user_id": user_id,
                "username": username,
                "full_name": full_name,
                "address": address,
                "email": email,
                "phone": phone,
            })
        else:
            return jsonify({
                'error_code': 404,
                'error_message': 'Not found'
            })
    finally:
        connection.close()


@app.route('/api/products/', methods=['GET'])
def list_products():
    try:
        products_collection = get_mongo()['example']['products']
        cursor = products_collection.find(projection={})
        response = {
            'products': [
                {'id': product['_id']}
                for product in cursor
            ],
            'total': cursor.count()
        }
        return jsonify(response)
    finally:
        cursor.close()


@app.route('/api/products/<string:product_id>', methods=['GET'])
def get_product(product_id):
    products_collection = get_mongo()['example']['products']
    product = products_collection.find_one(filter={'_id': product_id})
    if product:
        product['id'] = product.pop('_id')
        return jsonify(product)
    else:
        return jsonify({
            'error_code': 404,
            'error_message': 'Not found'
        })


if __name__ == '__main__':
    app.run()
