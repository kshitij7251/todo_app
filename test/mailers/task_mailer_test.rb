require "test_helper"

class TaskMailerTest < ActionMailer::TestCase
  test "daily_digest" do
    mail = TaskMailer.daily_digest
    assert_equal "Daily digest", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "overdue_tasks" do
    mail = TaskMailer.overdue_tasks
    assert_equal "Overdue tasks", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "due_today_tasks" do
    mail = TaskMailer.due_today_tasks
    assert_equal "Due today tasks", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "weekly_summary" do
    mail = TaskMailer.weekly_summary
    assert_equal "Weekly summary", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
