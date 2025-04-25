CREATE DATABASE ecommercedb;
USE ecommercedb;

-- 1. Create brand table
CREATE TABLE brand (
  brand_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  logo_url VARCHAR(255) NULL,
  description TEXT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (brand_id),
  UNIQUE INDEX name_UNIQUE (name ASC) VISIBLE
); 

-- 2. Create product_category table
CREATE TABLE product_category (
  category_id INT NOT NULL AUTO_INCREMENT,
  parent_category_id INT NULL,
  name VARCHAR(100) NOT NULL,
  description TEXT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (category_id),
  INDEX fk_category_parent_idx (parent_category_id ASC) VISIBLE,
  CONSTRAINT fk_category_parent
    FOREIGN KEY (parent_category_id)
    REFERENCES product_category (category_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- 3. Create product table
CREATE TABLE product (
  product_id INT NOT NULL AUTO_INCREMENT,
  brand_id INT NOT NULL,
  category_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  base_price DECIMAL(10,2) NOT NULL,
  description TEXT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (product_id),
  INDEX fk_product_brand_idx (brand_id ASC) VISIBLE,
  INDEX fk_product_category_idx (category_id ASC) VISIBLE,
  CONSTRAINT fk_product_brand
    FOREIGN KEY (brand_id)
    REFERENCES brand (brand_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_product_category
    FOREIGN KEY (category_id)
    REFERENCES product_category (category_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- 4. Create product_image table
CREATE TABLE product_image (
  image_id INT NOT NULL AUTO_INCREMENT,
  product_id INT NOT NULL,
  image_url VARCHAR(255) NOT NULL,
  is_primary TINYINT NOT NULL DEFAULT 0,
  display_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (image_id),
  INDEX fk_image_product_idx (product_id ASC) VISIBLE,
  CONSTRAINT fk_image_product
    FOREIGN KEY (product_id)
    REFERENCES product (product_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- 5. Create color table
CREATE TABLE color (
  color_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  hex_code CHAR(7) NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (color_id),
  UNIQUE INDEX name_UNIQUE (name ASC) VISIBLE
);

-- 6. Create size_category table
CREATE TABLE size_category (
  size_category_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(255) NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (size_category_id),
  UNIQUE INDEX name_UNIQUE (name ASC) VISIBLE
);

-- 7. Create size_option table
CREATE TABLE size_option (
  size_option_id INT NOT NULL AUTO_INCREMENT,
  size_category_id INT NOT NULL,
  name VARCHAR(50) NOT NULL,
  value VARCHAR(50) NOT NULL,
  display_order INT NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (size_option_id),
  INDEX fk_size_category_idx (size_category_id ASC) VISIBLE,
  CONSTRAINT fk_size_category
    FOREIGN KEY (size_category_id)
    REFERENCES size_category (size_category_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- 8. Create product_item table
CREATE TABLE product_item (
  item_id INT NOT NULL AUTO_INCREMENT,
  product_id INT NOT NULL,
  SKU VARCHAR(50) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  quantity_in_stock INT NOT NULL DEFAULT 0,
  is_active TINYINT NOT NULL DEFAULT 1,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (item_id),
  UNIQUE INDEX SKU_UNIQUE (SKU ASC) VISIBLE,
  INDEX fk_item_product_idx (product_id ASC) VISIBLE,
  CONSTRAINT fk_item_product
    FOREIGN KEY (product_id)
    REFERENCES product (product_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Create product_variation table
CREATE TABLE product_variation (
  variation_id INT NOT NULL AUTO_INCREMENT,
  product_item_id INT NOT NULL,
  size_option_id INT NULL,
  color_id INT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (variation_id),
  INDEX fk_variation_item_idx (product_item_id ASC) VISIBLE,
  INDEX fk_variation_size_idx (size_option_id ASC) VISIBLE,
  INDEX fk_variation_color_idx (color_id ASC) VISIBLE,
  CONSTRAINT fk_variation_item
    FOREIGN KEY (product_item_id)
    REFERENCES product_item (item_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_variation_size
    FOREIGN KEY (size_option_id)
    REFERENCES size_option (size_option_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_variation_color
    FOREIGN KEY (color_id)
    REFERENCES color (color_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- 10. Create attribute_category table
CREATE TABLE attribute_category (
  attribute_category_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  description VARCHAR(255) NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (attribute_category_id),
  UNIQUE INDEX name_UNIQUE (name ASC) VISIBLE
);

-- 11. Create attribute_type table
CREATE TABLE attribute_type (
  attribute_type_id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  data_type VARCHAR(50) NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (attribute_type_id),
  UNIQUE INDEX name_UNIQUE (name ASC) VISIBLE
);

-- 12. Create product_attribute table
CREATE TABLE product_attribute (
  attribute_id INT NOT NULL AUTO_INCREMENT,
  product_id INT NOT NULL,
  attribute_category_id INT NOT NULL,
  attribute_type_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,
  value TEXT NOT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (attribute_id),
  INDEX fk_attribute_product_idx (product_id ASC) VISIBLE,
  INDEX fk_attribute_category_idx (attribute_category_id ASC) VISIBLE,
  INDEX fk_attribute_type_idx (attribute_type_id ASC) VISIBLE,
  CONSTRAINT fk_attribute_product
    FOREIGN KEY (product_id)
    REFERENCES product (product_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_attribute_category
    FOREIGN KEY (attribute_category_id)
    REFERENCES attribute_category (attribute_category_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_attribute_type
    FOREIGN KEY (attribute_type_id)
    REFERENCES attribute_type (attribute_type_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- Insert sample size categories
INSERT INTO size_category (name, description) VALUES 
('Clothing', 'Standard clothing sizes'),
('Shoes', 'Shoe sizes'),
('Electronics', 'Size categories for electronic devices');

-- Insert sample colors
INSERT INTO color (name, hex_code) VALUES 
('Red', '#FF0000'),
('Blue', '#0000FF'),
('Black', '#000000'),
('White', '#FFFFFF'),
('Green', '#00FF00');

-- Insert sample attribute types
INSERT INTO attribute_type (name, data_type) VALUES 
('Text', 'string'),
('Number', 'decimal'),
('Boolean', 'boolean'),
('Date', 'date');

-- Insert sample attribute categories
INSERT INTO attribute_category (name, description) VALUES 
('Physical', 'Physical attributes like weight, dimensions'),
('Technical', 'Technical specifications'),
('Material', 'Material information');

-- Insert sample brands
INSERT INTO brand (name, description) VALUES 
('Nike', 'Sports apparel and footwear'),
('Apple', 'Consumer electronics'),
('Samsung', 'Electronics manufacturer');

-- Insert sample product categories
INSERT INTO product_category (name, description, parent_category_id) VALUES 
('Electronics', 'Electronic devices', NULL);

INSERT INTO product_category (name, description, parent_category_id) VALUES 
('Smartphones', 'Mobile phones', 1);

INSERT INTO product_category (name, description, parent_category_id) VALUES 
('Clothing', 'Apparel items', NULL);

INSERT INTO product_category (name, description, parent_category_id) VALUES 
('T-shirts', 'Short-sleeved shirts', 3);

-- Insert sample size options
INSERT INTO size_option (size_category_id, name, value, display_order) VALUES 
(1, 'S', 'Small', 1),
(1, 'M', 'Medium', 2),
(1, 'L', 'Large', 3),
(1, 'XL', 'Extra Large', 4),
(2, '40', 'EU 40', 1),
(2, '41', 'EU 41', 2),
(2, '42', 'EU 42', 3);
