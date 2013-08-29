defmodule Rethinkdb.Rql.Test do
  use Rethinkdb.Case, async: false

  defmodule RqlTest do
    use Rethinkdb.Rql
  end

  def r, do: RqlTest

  test "defines a terms to generate a ql2 terms" do
    rql  = r.expr(1)
    term = QL2.Term.new(type: :'DATUM', datum: QL2.Datum.from_value(1))
    assert term == rql.terms
  end

  setup_all do
    {:ok, conn: r.connect(db: "test") }
  end

  test "drop database", var do
    r.db_drop("heroes").run(var[:conn])
    assert_raise Rethinkdb.ResponseError, fn ->
      r.db("heroes").info.run!(var[:conn])
    end
  end

  test "create database", var do
    r.db_drop("heroes").run(var[:conn])
    assert HashDict.new(created: 1) == r.db_create("heroes").run!(var[:conn])
  end

  test :expr, var do
    assert 1_000 == r.expr(1_000).run!(var[:conn])
    assert "bob" == r.expr("bob").run!(var[:conn])
    assert true  == r.expr(true ).run!(var[:conn])
    assert false == r.expr(false).run!(var[:conn])
    assert 3.122 == r.expr(3.122).run!(var[:conn])
    assert [1, 2, 3, 4, 5] == r.expr([1, 2, 3, 4, 5]).run!(var[:conn])
  end

  test "expr to hash values", var do
    values = [a: 1, b: 2]
    assert HashDict.new(values) == r.expr(HashDict.new(values)).run!(var[:conn])
    assert HashDict.new(values) == r.expr(values).run!(var[:conn])
  end

  test "expr to expr values" do
    assert r.expr(1).terms == r.expr(r.expr(1)).terms
    assert r.expr(1).terms == r.expr(r.expr(1).terms).terms
  end

  test "logic operators", var do
    assert false == r.expr(1).eq(2).run!(var[:conn])
    assert true  == r.expr(1).ne(2).run!(var[:conn])
    assert false == r.expr(1).gt(2).run!(var[:conn])
    assert false == r.expr(1).ge(2).run!(var[:conn])
    assert true  == r.expr(1).lt(2).run!(var[:conn])
    assert true  == r.expr(1).le(2).run!(var[:conn])

    assert true  == r.expr(false).not.run!(var[:conn])
    assert true  == r.expr(true).and(true).run!(var[:conn])
    assert true  == r.expr(false).or(true).run!(var[:conn])
  end

  test "math operators", var do
    assert 3 == r.expr(2).add(1).run!(var[:conn])
    assert 1 == r.expr(2).add(-1).run!(var[:conn])
    assert 1 == r.expr(2).sub(1).run!(var[:conn])
    assert 4 == r.expr(2).mul(2).run!(var[:conn])
    assert 1 == r.expr(2).div(2).run!(var[:conn])
    assert 2 == r.expr(12).mod(10).run!(var[:conn])
  end

  test "define append and prepend", var do
    array = [1, 2, 3, 4]
    assert array ++ [5] == r.expr(array).append(5).run!(var[:conn])
    assert [0 | array]  == r.expr(array).prepend(0).run!(var[:conn])
  end

  test "get info", var do
    result = HashDict.new(type: "NUMBER", value: "1")
    assert result == r.expr(1).info.run!(var[:conn])
  end

  test "defines a run to call run with connect" do
    Exmeck.mock_run Rethinkdb.Utils.RunQuery do
      mock.stubs(:run, [:_, :_], {:ok, :result})
      mock.stubs(:run!, [:_, :_], :result)

      conn = r.connect
      rql  = r.expr(1)

      assert {:ok, :result} == rql.run(conn)
      assert 1 == mock.num_calls(:run, [rql.terms, conn])

      assert :result == rql.run!(conn)
      assert 1 == mock.num_calls(:run!, [rql.terms, conn])
    end
  end

  test "return a connection with parameters" do
    conn = r.connect(host: "localhost")
    assert "localhost" == conn.host

    conn = r.connect("rethinkdb://localhost")
    assert "localhost" == conn.host
  end

  test "return a connection record" do
    conn = r.connect
    assert is_record(conn, Rethinkdb.Connection)
  end
end

