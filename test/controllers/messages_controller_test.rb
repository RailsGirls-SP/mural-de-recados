require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  teardown do
    ENV.delete("READ_ONLY")
    ENV.delete("ADMIN_PASSWORD")
  end

  test "mostra o mural" do
    get root_url
    assert_response :success
    assert_select "a", text: "Novo recado"
  end

  test "sem READ_ONLY, qualquer pessoa pode postar" do
    assert_difference("Message.count") do
      post messages_url, params: { message: { author: "Ana", content: "Oi!" } }
    end
  end

  test "com READ_ONLY, ninguém posta, edita ou apaga" do
    ENV["READ_ONLY"] = "true"

    get root_url
    assert_select "a", text: "Novo recado", count: 0
    assert_select "a", text: "Editar", count: 0

    assert_no_difference("Message.count") do
      post messages_url, params: { message: { author: "Ana", content: "Oi!" } }
    end
    assert_redirected_to root_url

    assert_no_difference("Message.count") do
      delete message_url(messages(:one))
    end
  end

  test "com READ_ONLY, o admin pode editar" do
    ENV["READ_ONLY"] = "true"
    ENV["ADMIN_PASSWORD"] = "segredo"

    post admin_url, params: { password: "segredo" }
    assert_redirected_to root_url

    assert_difference("Message.count", -1) do
      delete message_url(messages(:one))
    end
  end

  test "senha errada não vira admin" do
    ENV["READ_ONLY"] = "true"
    ENV["ADMIN_PASSWORD"] = "segredo"

    post admin_url, params: { password: "errada" }
    assert_response :unprocessable_entity

    get new_message_url
    assert_redirected_to root_url
  end

  test "remover o ADMIN_PASSWORD desliga o admin já logado" do
    ENV["READ_ONLY"] = "true"
    ENV["ADMIN_PASSWORD"] = "segredo"
    post admin_url, params: { password: "segredo" }

    ENV.delete("ADMIN_PASSWORD")

    get new_message_url
    assert_redirected_to root_url
  end
end
