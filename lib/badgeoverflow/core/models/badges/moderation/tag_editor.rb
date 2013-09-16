require_relative '../badge'

class StackOverflow::TagEditor < StackOverflow::Badge
  def series
    :tag_editor
  end
end

class StackOverflow::ResearchAssistant < StackOverflow::TagEditor
end
