class AddCreatedByIdAndUpdatedByIdToProblems < ActiveRecord::Migration
  class Problem < ActiveRecord::Base
    self.table_name = :problem_problems
  end

  class User < ActiveRecord::Base
  end

  def up
    add_reference :problem_problems, :created_by, references: :users, index: true, null: true
    add_foreign_key :problem_problems, :users, column: :created_by_id

    add_reference :problem_problems, :updated_by, references: :users, index: true, null: true
    add_foreign_key :problem_problems, :users, column: :updated_by_id

    update_problem_user_column_with_a_random_user_so_we_can_set_null_false(:created_by_id)
    change_column_null :problem_problems, :created_by_id, false
  end

  def down
    remove_foreign_key :problem_problems, column: :created_by_id
    remove_reference :problem_problems, :created_by

    remove_foreign_key :problem_problems, column: :updated_by_id
    remove_reference :problem_problems, :updated_by
  end

  private

  def update_problem_user_column_with_a_random_user_so_we_can_set_null_false(column_name)
    random_user = User.first

    Problem.all.each do |problem|
      next if problem.send(column_name).present?
      problem.update_attributes(column_name => random_user.id)
    end
  end
end
