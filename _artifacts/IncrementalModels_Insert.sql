INSERT INTO JAFFLE_SHOP.RAW.ORDERS
   VALUES
     (100, 100, '2025-02-15', 'shipped', current_timestamp)
    ,(101, 84, '2025-02-15', 'shipped', current_timestamp)
    ,(102, 42, '2025-02-15', 'shipped', current_timestamp)
    ,(103, 101, '2025-02-15', 'shipped', current_timestamp)
    ,(104, 66, '2025-02-15', 'shipped', current_timestamp);

INSERT INTO JAFFLE_SHOP.RAW.CUSTOMERS
   VALUES
      (101, 'Michelle', 'B.', current_timestamp)
     ,(102, 'Faith', 'L.', current_timestamp);

INSERT INTO JAFFLE_SHOP.RAW.PAYMENTS
   VALUES
      (121, 100, 'bank_transfer', 'success', 1000, '2025-02-14', current_timestamp)
     ,(122, 101, 'credit_card', 'fail', 400, '2025-02-14', current_timestamp)
     ,(123, 102, 'credit_card', 'success', 1900, '2025-02-14', current_timestamp)
     ,(124, 103, 'credit_card', 'success', 1000,  '2025-02-15', current_timestamp)
     ,(125, 104, 'coupon', 'success', 100, '2025-02-15', current_timestamp);