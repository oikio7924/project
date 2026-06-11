ALTER TABLE ht_bill_power_plant_recipient_contract
    ADD COLUMN item_name VARCHAR(255) NULL COMMENT '품목명' AFTER grand_total;

