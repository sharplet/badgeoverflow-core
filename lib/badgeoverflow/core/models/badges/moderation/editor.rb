require_relative '../badge'

class StackOverflow::Editor < StackOverflow::Badge
  def series
    :editor
  end
end

class StackOverflow::StrunkWhite < StackOverflow::Editor
end

class StackOverflow::CopyEditor < StackOverflow::Editor
end
