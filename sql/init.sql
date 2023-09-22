-- Create a database
CREATE DATABASE pssql;

-- Use the database
USE pssql;

-- Create a table for your data
CREATE TABLE IF NOT EXISTS items (
    id SERIAL PRIMARY KEY,
    name TEXT,
    description TEXT
);
