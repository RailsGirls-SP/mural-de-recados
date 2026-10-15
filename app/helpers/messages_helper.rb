module MessagesHelper
  URL_REGEX = %r{https?://[^\s<>"]+[^\s<>".,;:!?)\]]}

  def message_content(text)
    parts = text.split(/(#{URL_REGEX})/).map do |part|
      if part.match?(/\A#{URL_REGEX}\z/)
        link_to part, part, target: "_blank", rel: "noopener noreferrer"
      else
        part
      end
    end

    simple_format(safe_join(parts), {}, sanitize: false)
  end
end
