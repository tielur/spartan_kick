defmodule SpartanKickWeb.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(Plug.Logger, log: :debug)

  plug(:match)
  plug(:dispatch)

  # Simple GET Request handler for path /hello
  get "/hello" do
    send_resp(conn, 200, "world")
  end

  post "/spartan_kick" do
    # Get initial command
    {:ok, body, conn} = read_body(conn)
    body = URI.decode_query(body)
    # Slack requires a response with 3000ms
    conn = send_resp(conn, 200, "")

    response_url = body["response_url"]
    IO.inspect(body)

    # Get MEME
    meme_body =
      URI.encode_query(%{
        "template_id" => 1_650_385,
        "text1" => "This is Sparta",
        "text0" => String.trim(body["text"]),
        "username" => System.get_env("IMGFLIP_USERNAME"),
        "password" => System.get_env("IMGFLIP_PASSWORD")
      })

    {:ok, meme_response} =
      HTTPoison.post(
        "https://api.imgflip.com/caption_image",
        meme_body,
        %{"Content-type" => "application/x-www-form-urlencoded"}
      )

    meme_response_body = Poison.decode!(meme_response.body)

    # Send Meme to response_url
    slack_body =
      Poison.encode!(%{
        "response_type" => "in_channel",
        "text" => meme_response_body["data"]["url"]
      })

    HTTPoison.post(
      response_url,
      slack_body,
      %{"Content-type" => "application/json"}
    )

    conn
  end

  # "Default" route that will get called when no other route is matched
  match _ do
    send_resp(conn, 404, "not found")
  end
end
