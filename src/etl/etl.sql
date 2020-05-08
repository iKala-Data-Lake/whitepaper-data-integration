SELECT
  orders.user_id,
  orders.order_id,
  orders.order_date,
  orders.product_id,
  orders.option_id,
  flat_products.* EXCEPT(product_id, option_id),
  orders.* EXCEPT(user_id, order_id, product_id, option_id, order_date)
FROM (
    -- flatten products.OPTIONS
    SELECT
      products.id AS product_id,
      products.name AS product_name,
      products.descriptions AS product_descriptions,
      category.id AS category_id,
      category.name AS category_name,
      vendor.id AS vendor_id,
      vendor.name AS vendor_name,
      vendor.email AS vendor_email,
      vendor.phone AS vendor_phone,
      OPTIONS.id AS option_id,
      OPTIONS.name AS option_name,
      OPTIONS.quantity AS option_quantity,
      OPTIONS.on_sale AS option_on_sale,
      OPTIONS.price AS option_price,
      OPTIONS.specs AS option_specs
    FROM ikala_data_integration_sandbox.products, products.OPTIONS
  ) flat_products, ikala_data_integration_sandbox.orders 
WHERE
  orders.product_id = flat_products.product_id AND orders.option_id = flat_products.option_id
ORDER BY
  order_date DESC, user_id, order_id, product_id, option_id