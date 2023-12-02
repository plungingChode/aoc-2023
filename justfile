set dotenv-load

# download the input for a given day
get DAY:
    aoc download --year 2023 --day {{DAY}} --input-only --input-file day{{DAY}}/input

# submit a result
submit DAY PART:
    cd day{{DAY}} && elixir -r *.ex main.exs \
    | (read answer; \
    aoc submit --year 2023 --day {{DAY}} {{PART}} $answer)

# run tests for a day
test DAY *ARGS:
    @clear
    @-cd day{{DAY}} && elixir -r *.ex main_test.exs

run DAY:
    @-cd day{{DAY}} && elixir -r *.ex main.exs
    

