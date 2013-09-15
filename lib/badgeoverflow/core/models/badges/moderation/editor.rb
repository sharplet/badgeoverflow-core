require_relative '../badge'

class Editor < Badge
  def series
    :editor
  end
end

class StrunkWhite < Editor
end

class CopyEditor < Editor
end
