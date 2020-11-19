require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL
    arr_of_students = DB[:conn].execute(sql)
    arr_of_students.collect do |s|
      self.new_from_db(s)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students 
    WHERE students.name = ?
    SQL

    student = DB[:conn].execute(sql, name)[0]
    self.new_from_db(student)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students 
    WHERE grade = 9
    SQL
    arr_of_students = DB[:conn].execute(sql)
    arr_of_students.collect do |s|
      self.new_from_db(s)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL
    arr_of_students = DB[:conn].execute(sql)
    arr_of_students.collect do |s|
      self.new_from_db(s)
    end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * FROM students
    WHERE GRADE = 10
    LIMIT ?
    SQL
    arr_of_students = DB[:conn].execute(sql, x)
    arr_of_students.collect {|s| self.new_from_db(s)}
  end

  def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
  end 

  def self.all_students_in_grade_X(x)
    self.all.collect do |s|
      s.grade == x
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
