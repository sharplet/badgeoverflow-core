require_relative '../badge'

class StackOverflow::Custodian < StackOverflow::Badge
  def series
    :custodian
  end
end

class StackOverflow::Reviewer < StackOverflow::Custodian
end

class StackOverflow::Steward < StackOverflow::Custodian
end
