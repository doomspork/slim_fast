defmodule RenderKeepLinesTest do
  use ExUnit.Case

  import Slime, only: [render: 1]

  setup do
    keep_lines_was = Application.get_env(:slime, :keep_lines)
    Application.put_env(:slime, :keep_lines, true)
    on_exit fn ->
      Application.put_env(:slime, :keep_lines, keep_lines_was)
    end
  end

  test "Keep simple tags lines" do
    slime = """
    h1 test
    h2 multiple
    h3 lines
    """
    assert render(slime) == """
    <h1>test</h1>
    <h2>multiple</h2>
    <h3>lines</h3>
    """ |> String.strip
  end

  test "Keep tags with childs lines" do
    slime = """
    h1
      | test
      | multiple
      | lines
    """
    assert render(slime) == """
    <h1>
    test
    multiple
    lines</h1>
    """ |> String.strip
  end

  test "Keep tags with inline and nested childs lines" do
    slime = """
    h1 test
      | multiple
      | lines
    """
    assert render(slime) == """
    <h1>test
    multiple
    lines</h1>
    """ |> String.strip
  end

  test "Keep lines when empty lines present" do
    slime = """
    h1 test

      | multiple

      | lines
    """
    assert render(slime) == """
    <h1>test

    multiple

    lines</h1>
    """ |> String.strip
  end

  test "Keep lines for inline tags" do
    slime = """
    h1: span test
    """
    assert render(slime) == """
    <h1><span>test</span></h1>
    """ |> String.strip
  end

  test "Keep lines for inline tags with children" do
    slime = """
    h1: span test
      span test 1
    """
    assert render(slime) == """
    <h1><span>test</span>
    <span>test 1</span></h1>
    """ |> String.strip
  end
end
