require! {findit, child_process.spawn}

optionator = (require \optionator) options:
  * option: \require
    alias: \r
    type: '[String]'
    description: 'Modules to require before running'
  * option: \command
    alias: \c
    type: \String
    default: \node
    description: 'Command to run'

opts = optionator.parse process.argv

all-on = (type, fn, evs)-->
  args = []
  evs.for-each (.once type, -> args.push it; if args.length is evs.length then fn ...args)

flip = (f, a, b)--> f b,a
map = flip (.map _)
sum = (.reduce (+), 0)

opts[]require.for-each require
run = ([] ++ ) >> spawn opts.command, _, {stdio:\inherit}

opts._
|> map (findit _) >> (.on \file run)
|> all-on \exit (...codes)->
  process.exit sum codes