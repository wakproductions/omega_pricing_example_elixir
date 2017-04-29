defmodule ErrorLogger do

  # We could make this a lot more sophisticated, but keeping it a simple output message for now
  def call(message) do
    message |> IO.puts
  end

end