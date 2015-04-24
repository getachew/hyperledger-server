defmodule Hyperledger.ParamsHelpersTest do
  use ExUnit.Case, async: true
    
  test "`underscore_keys` recsively converts keys" do
    test = %{"fooBar" => %{"fizzBuzz" => %{"loremIpsum" => "noChange"}}}
    assert Hyperledger.ParamsHelpers.underscore_keys(test) ==
      %{"foo_bar" => %{"fizz_buzz" => %{"lorem_ipsum" => "noChange"}}}
  end
end
