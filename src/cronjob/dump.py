#! /bin/env python3

import json
import os

import click
import pymysql
from pymongo import MongoClient

BUCKET = 'ikala-data-integration-sandbox-{GCP_PROJECT}'.format(
    GCP_PROJECT=os.getenv('GCP_PROJECT')
)


@click.command(name='mongo')
def dump_mongo():
    DESTINATION_BLOB = 'mongo/example-products.jsonl'
    TEMP_FILE = 'mongo.jsonl'

    print('Connecting MongoDB')

    client = MongoClient('mongodb://{user}:{password}@{host}:27017/'.format(
        host=os.getenv('MONGODB_CONTAINER_NAME', 'localhost'),
        user=os.getenv('MONGO_USERNAME', 'mongo'),
        password=os.getenv('MONGO_PASSWORD', '12345678'),
    ))
    products_collection = client['example']['products']

    print('Retrieving data')

    cursor = products_collection.find()
    with open(TEMP_FILE, 'w') as f:
        for product in cursor:
            product['id'] = product.pop('_id')
            json_str = json.dumps(product)
            f.write(json_str + '\n')

    print('Uploading data')

    from google.cloud import storage
    storage_client = storage.Client(project=os.getenv('GCP_PROJECT'))
    bucket = storage_client.bucket(BUCKET)
    blob = bucket.blob(DESTINATION_BLOB)
    blob.upload_from_filename(TEMP_FILE)

    print('File {} uploaded to {}.'.format(
        TEMP_FILE, DESTINATION_BLOB
    ))


@click.command(name='mysql')
def dump_mysql():
    DESTINATION_BLOB = 'mysql/example-orders.jsonl'
    TEMP_FILE = 'mysql.jsonl'

    print('Connecting MySQL')

    connection = pymysql.connect(
        host=os.getenv('MYSQL_CONTAINER_NAME', 'localhost'),
        db='example',
        user=os.getenv('MYSQL_USERNAME', 'root'),
        password=os.getenv('MYSQL_PASSWORD', '12345678'),
        cursorclass=pymysql.cursors.DictCursor,
    )

    print('Retrieving data')

    try:
        with connection.cursor() as cursor:
            cursor.execute(
                '''
                SELECT
                    orders_placed_user.user_id,
                    orders_placed_user.order_id,
                    orders_has_products.product_id,
                    orders_has_products.option_id,
                    orders_has_products.quantity,
                    orders.total_item,
                    orders.shipping_fee,
                    orders.tax,
                    orders.total_cost,
                    orders.order_date,
                    orders.delivery_date,
                    orders.ship_name,
                    orders.ship_address,
                    orders.tracking_number,
                    orders.delivery_status
                FROM orders_has_products, orders_placed_user, orders
                WHERE orders_has_products.order_id=orders_placed_user.order_id
                AND orders_has_products.order_id=orders.order_id
                ORDER BY order_date DESC, user_id, order_id
                '''
            )
            column_names = [
                column_info[0] for column_info in cursor.description
            ]

            with open(TEMP_FILE, 'w') as f:
                rows = cursor.fetchall()
                for row in rows:
                    json_str = json.dumps(row, default=str)
                    f.write(json_str + '\n')
    finally:
        connection.close()

    print('Uploading data')

    from google.cloud import storage
    storage_client = storage.Client(project=os.getenv('GCP_PROJECT'))
    bucket = storage_client.bucket(BUCKET)
    blob = bucket.blob(DESTINATION_BLOB)
    blob.upload_from_filename(TEMP_FILE)

    print('File {} uploaded to {}.'.format(
        TEMP_FILE, DESTINATION_BLOB
    ))


@click.group(name='cli')
def cli():
    pass


cli.add_command(dump_mongo)
cli.add_command(dump_mysql)

if __name__ == '__main__':
    cli()
