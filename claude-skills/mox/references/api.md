# Mox - Api

**Pages:** 3

---

## View Source Mox (Mox v1.2.0)

**URL:** https://hexdocs.pm/mox/Mox.html

**Contents:**
- View Source Mox (Mox v1.2.0)
- Example
- Multiple behaviours
- Compile-time requirements
- Multi-process collaboration
  - Explicit allowances
    - Explicit allowances as lazy/deferred functions
  - Global mode
  - Blocking on expectations
- Summary

Mox is a library for defining concurrent mocks in Elixir.

The library follows the principles outlined in "Mocks and explicit contracts", summarized below:

No ad-hoc mocks. You can only create mocks based on behaviours

No dynamic generation of modules during tests. Mocks are preferably defined in your test_helper.exs or in a setup_all block and not per test

Concurrency support. Tests using the same mock can still use async: true

Rely on pattern matching and function clauses for asserting on the input instead of complex expectation rules

Imagine that you have an app that has to display the weather. At first, you use an external API to give you the data given a lat/long pair:

However, you want to test the code above without performing external API calls. How to do so?

First, it is important to define the WeatherAPI behaviour that we want to mock. And we will define a proxy function that will dispatch to the desired implementation:

By default, we will dispatch to MyApp.ExternalWeatherAPI, which now contains the external API implementation.

If you want to mock the WeatherAPI behaviour during tests, the first step is to define the mock with defmock/2, usually in your test_helper.exs, and configure your application to use it:

Now in your tests, you can define expectations with expect/4 and verify them via verify_on_exit!/1:

All expectations are defined based on the current process. This means multiple tests using the same mock can still run concurrently unless the Mox is set to global mode. See the "Multi-process collaboration" section.

One last note, if the mock is used throughout the test suite, you might want the implementation to fall back to a stub (or actual) implementation when no expectations are defined. You can use stub_with/2 in a case template that is used throughout your test suite:

Now, for every test case that uses ExUnit.Case, it can use MyApp.Case instead. Then, if no expectations are defined it will call the implementation in MyApp.StubWeatherAPI.

Mox supports defining mocks for multiple behaviours.

Suppose your library also defines a behaviour for getting past weather:

You can mock both the weather and past weather behaviour:

If the mock needs to be available during the project compilation, for instance because you get undefined function warnings, then instead of defining the mock in your test_helper.exs, you should instead define it under test/support/mocks.ex:

Then you need to make sure that files in test/support get compil

*[Content truncated]*

**Examples:**

Example 1 (python):
```python
defmodule MyApp.HumanizedWeather do
  def display_temp({lat, long}) do
    {:ok, temp} = MyApp.WeatherAPI.temp({lat, long})
    "Current temperature is #{temp} degrees"
  end

  def display_humidity({lat, long}) do
    {:ok, humidity} = MyApp.WeatherAPI.humidity({lat, long})
    "Current humidity is #{humidity}%"
  end
end
```

Example 2 (python):
```python
defmodule MyApp.WeatherAPI do
  @callback temp(MyApp.LatLong.t()) :: {:ok, integer()}
  @callback humidity(MyApp.LatLong.t()) :: {:ok, integer()}

  def temp(lat_long), do: impl().temp(lat_long)
  def humidity(lat_long), do: impl().humidity(lat_long)
  defp impl, do: Application.get_env(:my_app, :weather, MyApp.ExternalWeatherAPI)
end
```

Example 3 (unknown):
```unknown
Mox.defmock(MyApp.MockWeatherAPI, for: MyApp.WeatherAPI)
Application.put_env(:my_app, :weather, MyApp.MockWeatherAPI)
```

Example 4 (unknown):
```unknown
defmodule MyApp.HumanizedWeatherTest do
  use ExUnit.Case, async: true

  import Mox

  # Make sure mocks are verified when the test exits
  setup :verify_on_exit!

  test "gets and formats temperature and humidity" do
    MyApp.MockWeatherAPI
    |> expect(:temp, fn {_lat, _long} -> {:ok, 30} end)
    |> expect(:humidity, fn {_lat, _long} -> {:ok, 60} end)

    assert MyApp.HumanizedWeather.display_temp({50.06, 19.94}) ==
             "Current temperature is 30 degrees"

    assert MyApp.HumanizedWeather.display_humidity({50.06, 19.94}) ==
             "Current humidity is 60%"
  end
end
```

---

## 

**URL:** https://hexdocs.pm/mox/Mox.epub

---

## View Source Mox.UnexpectedCallError exception (Mox v1.2.0)

**URL:** https://hexdocs.pm/mox/Mox.UnexpectedCallError.html

**Contents:**
- View Source Mox.UnexpectedCallError exception (Mox v1.2.0)

Hex Package Hex Preview Search HexDocs Download ePub version

Built using ExDoc (v0.34.2) for the Elixir programming language

---
