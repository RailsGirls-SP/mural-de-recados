require "test_helper"

class MessagesHelperTest < ActionView::TestCase
  test "transforma a URL em link que abre em outra aba" do
    html = message_content("Olha o guia https://guides.railsgirls.com/app")

    assert_includes html, %(<a target="_blank" rel="noopener noreferrer" href="https://guides.railsgirls.com/app">https://guides.railsgirls.com/app</a>)
  end

  test "não inclui a pontuação final no link" do
    html = message_content("Veja isso: https://railsgirls.com. E também (https://rubyonrails.org)!")

    assert_includes html, %(href="https://railsgirls.com")
    assert_includes html, %(href="https://rubyonrails.org")
    assert_includes html, "</a>. E também"
    assert_includes html, "</a>)!"
  end

  test "escapa HTML digitado no recado" do
    html = message_content(%(<script>alert("oi")</script> https://railsgirls.com))

    assert_not_includes html, "<script>"
    assert_includes html, "&lt;script&gt;"
    assert_includes html, %(href="https://railsgirls.com")
  end

  test "mantém o & da URL sem escapar duas vezes" do
    html = message_content("https://site.com/busca?a=1&b=2")

    assert_includes html, %(href="https://site.com/busca?a=1&amp;b=2")
  end

  test "preserva as quebras de linha" do
    html = message_content("Primeira linha\nSegunda linha")

    assert_includes html, "Primeira linha\n<br />Segunda linha"
  end
end
