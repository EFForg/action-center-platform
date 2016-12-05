
When /^there is a persisted ([\w:]+)$/ do |model|
  @persisted_records ||= []
  @persisted_records << Kernel.const_get(model).create!
end

When /^there is a persisted ([\w:]+) with:$/ do |model, fields|
  @persisted_records ||= []
  @persisted_records << Kernel.const_get(model).create!(fields.rows_hash)
end

When /^(it|that) has a persisted item belonging to ([\w]+)$/ do |it_or_that, association|
  if it_or_that == "it"
    @persisted_records << @persisted_records[0].send(association).create!
  else
    @persisted_records << @persisted_records[-1].send(association).create!
  end
end

When /^(it|that) has a persisted item belonging to ([\w]+) with:$/ do |it_or_that, association, fields|
  if it_or_that == "it"
    @persisted_records << @persisted_records[0].send(association).create!(fields.rows_hash)
  else
    @persisted_records << @persisted_records[-1].send(association).create!(fields.rows_hash)
  end
end

When /^I pause a moment$/ do
  # this is not scientific
  sleep 0.1
end

Then /^there should( not)? be a persisted ([\w:]+) with:$/ do |negate, model, fields|
  step("I pause a moment")
  if negate
    expect(Kernel.const_get(model).find_by(fields.rows_hash)).to be_nil
  else
    expect(Kernel.const_get(model).find_by(fields.rows_hash)).not_to be_nil
  end
end

Then /^there should not be a persisted ([\w:]+)$/ do |model|
  step("I pause a moment")
  expect(Kernel.const_get(model).count).to eq(0)
end
