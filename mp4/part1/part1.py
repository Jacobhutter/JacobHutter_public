import state as s

Pong = s.State()

print Pong.get_tuple

print Pong.action(2) # move up

print Pong.action(1) # move down

print Pong.action(0) # nothing

print Pong.action(3)
