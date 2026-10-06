-- 1. USERS / PROFILES TABLE
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  role TEXT CHECK (role IN ('admin', 'staff', 'student')) DEFAULT 'student',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. INVENTORY COMPONENTS TABLE
CREATE TABLE components (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  total_qty INT NOT NULL CHECK (total_qty >= 0),
  in_stock INT NOT NULL CHECK (in_stock >= 0),
  damaged_qty INT DEFAULT 0 CHECK (damaged_qty >= 0),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. PARENT REQUESTS TABLE
CREATE TABLE requests (
  id SERIAL PRIMARY KEY,
  student_id UUID REFERENCES profiles(id),
  project_title TEXT NOT NULL,
  status TEXT CHECK (status IN ('Pending', 'Approved', 'Issued', 'Returned', 'Rejected')) DEFAULT 'Pending',
  requested_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  issued_at TIMESTAMP WITH TIME ZONE,
  returned_at TIMESTAMP WITH TIME ZONE
);

-- 4. CHILD REQUESTED ITEMS TABLE
CREATE TABLE request_items (
  id SERIAL PRIMARY KEY,
  request_id INT REFERENCES requests(id) ON DELETE CASCADE,
  component_id INT REFERENCES components(id),
  quantity INT NOT NULL CHECK (quantity > 0),
  status TEXT CHECK (status IN ('Issued', 'Returned', 'Damaged')) DEFAULT 'Issued'
);
