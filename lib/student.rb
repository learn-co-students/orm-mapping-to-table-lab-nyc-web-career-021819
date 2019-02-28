class Student

  attr_reader :id
  attr_accessor :name, :grade
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  def initialize(name, grade)
    self.name = name
    self.grade = grade
  end


  def self.create_table
    sql = <<-SQL
            CREATE TABLE
            IF NOT EXISTS students (
                id INTEGER PRIMARY KEY,
                name TEXT,
                grade TEXT
            );
          SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students;"
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students
      (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT * FROM students ORDER BY id DESC").first.first
  end

  def self.create(attributes)
    new_student = Student.new(attributes.values[0], attributes.values[1])
    new_student.save
    new_student
  end

end
