#coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

company = Company.create(name: "株式会社RAWHIDE")

admin = User::Administrator.create(email: "admin@raw-hide.co.jp", password: "adminadmin", password_confirmation: "adminadmin", company_id: company.id, name: "admin")
admin.create_profile(sex: 1, section: "システム管理部", position: "部長")

user = User::Staff.create(email: "st@raw-hide.co.jp", password: "staffstaff", password_confirmation: "staffstaff", company_id: company.id, name: "staff")

user.create_profile(sex: 1, section: "開発事業部", position: "リーダー")
report = ::ApprovalForm.create title: "私有情報持ち込み申請書", user_id: admin.id, header_text: "下記のとおり、私有情報システムの持ち込みを申請しますので、承認をお願いします。", fotter_text: "F3.4.3.2-06 私有情報システム持ち込み申請書"

report.fields << ::ApprovalFormField.new(form_type: "text", title: "申請部門")
report.fields << ::ApprovalFormField.new(form_type: "text", title: "利用者名")
report.fields << ::ApprovalFormField.new(form_type: "text", title: "メーカー名")


report.workflow_templates << ::WorkflowTemplate.new(step: 1, user_type: C.user_type.SystemOfficer)
report.workflow_templates << ::WorkflowTemplate.new(step: 2, user_type: C.user_type.Administrator)
