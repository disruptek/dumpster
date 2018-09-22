type
   State = object
      x: float32
      v: float32

   Derivative = object
      dx: float32
      dv: float32

proc acceleration(state: State, t: float64): float32 =
   let force = 10.0f
   let mass = 1.0f
   result = (force / mass) * state.x + state.v

proc evaluate(initial: State, t: float64, dt: float32, d: Derivative): Derivative =
   var state: State
   state.x = initial.x + d.dx*dt
   state.v = initial.v + d.dv*dt

   result.dx = state.v
   result.dv = acceleration(state, t+dt)

proc integrate(state: var State, t: float64, dt: float32) =
   var a, b, c, d: Derivative

   a = evaluate(state, t, 0.0f, Derivative())
   b = evaluate(state, t, dt*0.5f, a)
   c = evaluate(state, t, dt*0.5f, b)
   d = evaluate(state, t, dt, c)

   let dxdt = 1.0f / 6.0f *
      (a.dx + 2.0f * (b.dx + c.dx) + d.dx)

   let dvdt = 1.0f / 6.0f *
      (a.dv + 2.0f * (b.dv + c.dv) + d.dv)

   state.x = state.x + dxdt * dt
   state.v = state.v + dvdt * dt

var
   state = State(x: 0.0f, v: 0.0f)
   t = 10.0
   dt = 0.1f

integrate(state, t, dt)
echo "t = ", t, ": position = ", state.x, " velocity = ", state.v
