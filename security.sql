-- Enable security rules on tables
ALTER TABLE components ENABLE ROW LEVEL SECURITY;
ALTER TABLE requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE request_items ENABLE ROW LEVEL SECURITY;

-- Allow everyone (including students) to view active components in the catalog
CREATE POLICY "Public catalog view" ON components 
  FOR SELECT USING (is_active = TRUE);

-- Allow Staff and Admin to modify inventory counts
CREATE POLICY "Staff inventory management" ON components 
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'staff'))
  );

-- Allow Students to view their own borrowing requests
CREATE POLICY "Student personal requests" ON requests 
  FOR SELECT USING (
    student_id = auth.uid() OR 
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('admin', 'staff'))
  );
