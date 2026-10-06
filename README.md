# TinkerTrack
<<<<<<< HEAD

Cloud-Native Electronics Lab Inventory & Component Tracking System

TinkerTrack is a database-driven system designed for electronics labs and maker spaces to manage component inventory, student borrowing requests, and role-based access. The project is built around PostgreSQL/Supabase tables with Row Level Security (RLS), making it suitable for a cloud-native web application or admin dashboard.

## Overview

This repository contains the core database schema and security configuration for the application:

- `schema.sql` — core application tables
- `security.sql` — RLS policies and indexes
- `seed_data.sql` — sample inventory records

## Features

- Inventory management for electronics components
- Stock tracking across total quantity, available stock, and damaged stock
- Student request workflows for borrowing lab items
- Request status tracking: Pending, Approved, Issued, Returned, Rejected
- Item-level tracking for requested components
- Role-based access for admin, staff, and student users
- Secure access via Supabase auth and PostgreSQL RLS

## Core Tables

### `profiles`
Stores user identity and role information.

Columns:
- `id` — UUID linked to `auth.users`
- `email` — unique user email
- `full_name` — display name
- `role` — one of `admin`, `staff`, `student`
- `created_at` — account creation timestamp

### `components`
Stores the inventory catalog of available lab items.

Columns:
- `id` — serial primary key
- `name` — component name
- `category` — grouping such as sensors, actuators, displays, etc.
- `total_qty` — total stock count
- `in_stock` — currently available quantity
- `damaged_qty` — damaged or unusable items
- `is_active` — whether the item is active in the catalog
- `created_at` — creation time

### `requests`
Represents a borrowing request made by a student.

Columns:
- `id` — request identifier
- `student_id` — linked to the requesting student profile
- `project_title` — project or usage description
- `status` — request lifecycle state
- `requested_at` — when the request was created
- `issued_at` — when inventory was issued
- `returned_at` — when items were returned

### `request_items`
Tracks the individual components requested in each borrowing request.

Columns:
- `id` — line item identifier
- `request_id` — parent request reference
- `component_id` — requested component
- `quantity` — requested quantity
- `status` — item state such as `Issued`, `Returned`, or `Damaged`

## User Roles

The application supports three roles:

- `admin` — full access to manage the system and inventory
- `staff` — can manage stock and view request data
- `student` — can create requests and view their own request history

## Security Model

The project uses PostgreSQL Row Level Security policies in `security.sql`.

Key access rules include:

- All authenticated users can view active component inventory
- Students can view only their own requests
- Staff and admins can view all requests
- Students can insert their own request records
- Request item access is restricted based on the associated request ownership
- Staff/admin users can perform inventory management operations

## Seed Data

The `seed_data.sql` file populates the inventory with sample lab components such as:

- Arduino Uno R3
- Raspberry Pi 4
- Ultrasonic Sensor HC-SR04
- SG90 Micro Servo Motor
- Resistors
- Breadboards
- LCD displays
- Relay modules

## Recommended Setup

This repository is intended to be used in a Supabase/PostgreSQL environment.

1. Create a new Supabase project or connect to an existing PostgreSQL database.
2. Run `schema.sql` to create the tables.
3. Run `security.sql` to enable RLS and define access rules.
4. Run `seed_data.sql` to load initial catalog data.
5. Add users and profiles in `auth.users` and `profiles` to match your app flow.

## Example Workflow

1. A student creates a profile.
2. The student submits a borrowing request with a project title.
3. Staff or admin reviews the request and approves or rejects it.
4. Inventory is issued against the request item records.
5. Returned items update the request status and available stock.

## Notes

This repository focuses on the database layer and authorization rules. The frontend, API, and UI logic are intentionally not included here, allowing the schema to be reused in a variety of application stacks.

## Project Structure

```text
TinkerTrack/
├── README.md
├── schema.sql
├── security.sql
├── seed_data.sql
└── .sql files contain the database schema, access control, and sample data
```

## License

This project is provided as a starter database schema for lab and inventory workflows. Update the license terms as needed for your deployment environment.
=======
Cloud-Native Electronics Lab Inventory &amp; Component Tracking System
>>>>>>> eb794ea94e23a10179d5687f9d5803f3ea6fea22
