-- 1. DROP ALL OLD POLICIES TO CLEAR DUPLICATES & WARNINGS
DROP POLICY IF EXISTS "Public catalog view" ON components;
DROP POLICY IF EXISTS "Staff inventory management" ON components;
DROP POLICY IF EXISTS "Staff and Admin update stock" ON components;
DROP POLICY IF EXISTS "Admin full component management" ON components;
DROP POLICY IF EXISTS "Student personal requests" ON requests;
DROP POLICY IF EXISTS "Student insert requests" ON requests;
DROP POLICY IF EXISTS "Student insert request items" ON request_items;
DROP POLICY IF EXISTS "Request items view" ON request_items;
DROP POLICY IF EXISTS "Public profiles view" ON profiles;

-- 2. ENABLE RLS ON ALL 4 TABLES
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE components ENABLE ROW LEVEL SECURITY;
ALTER TABLE requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE request_items ENABLE ROW LEVEL SECURITY;

-- 3. CREATE OPTIMIZED RLS POLICIES (Using Cached Auth UIDs)
-- Profiles: Logged in users can view profile details
CREATE POLICY "Profiles read access" ON profiles 
  FOR SELECT TO authenticated 
  USING (TRUE);

-- Components: Everyone logged in can view active catalog
CREATE POLICY "Components read access" ON components 
  FOR SELECT TO authenticated 
  USING (is_active = TRUE);

-- Components: Staff and Admins can update/manage stock
CREATE POLICY "Components staff management" ON components 
  FOR ALL TO authenticated 
  USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = (SELECT auth.uid()) 
      AND profiles.role IN ('admin', 'staff')
    )
  );

-- Requests: Students see their own; Staff/Admins see all
CREATE POLICY "Requests read access" ON requests 
  FOR SELECT TO authenticated 
  USING (
    student_id = (SELECT auth.uid()) OR 
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE profiles.id = (SELECT auth.uid()) 
      AND profiles.role IN ('admin', 'staff')
    )
  );

-- Requests: Logged in users can create request entries
CREATE POLICY "Requests insert access" ON requests 
  FOR INSERT TO authenticated 
  WITH CHECK (student_id = (SELECT auth.uid()));

-- Request Items: Read permission connected to request ownership
CREATE POLICY "Request items read access" ON request_items 
  FOR SELECT TO authenticated 
  USING (
    EXISTS (
      SELECT 1 FROM requests 
      WHERE requests.id = request_items.request_id 
      AND (
        requests.student_id = (SELECT auth.uid()) OR 
        EXISTS (
          SELECT 1 FROM profiles 
          WHERE profiles.id = (SELECT auth.uid()) 
          AND profiles.role IN ('admin', 'staff')
        )
      )
    )
  );

-- Request Items: Insert permission for students creating order details
CREATE POLICY "Request items insert access" ON request_items 
  FOR INSERT TO authenticated 
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM requests 
      WHERE requests.id = request_items.request_id 
      AND requests.student_id = (SELECT auth.uid())
    )
  );

-- 4. CREATE INDEXES FOR FOREIGN KEYS (Fixes Unindexed Foreign Key Warnings)
CREATE INDEX IF NOT EXISTS idx_requests_student_id ON requests(student_id);
CREATE INDEX IF NOT EXISTS idx_request_items_request_id ON request_items(request_id);
CREATE INDEX IF NOT EXISTS idx_request_items_component_id ON request_items(component_id);
