import numpy as np
import matplotlib.pyplot as plt

# Model parameters
a = 0.7
b = 0.8
epsilon = 0.08
I_ext = 0.1

def FHmodel(v, w):
    dv = v - (v**3)/3 - w + I_ext
    dw = epsilon * (v + a - b*w)
    return dv, dw

def v_nullcline(v): # w(v) for dv/dt = 0
  return v - (v**3)/3 + I_ext

def w_nullcline(v): # w(v) for dw/dt = 0
  return (v + a) / b
  

def Euler(model, initial, Tmax, dt):
  steps = int(Tmax/dt)
  x_traj = np.zeros(steps)
  y_traj = np.zeros(steps)
  x_traj[0], y_traj[0] = initial

  for i in range(steps-1):
    dx, dy = model(x_traj[i], y_traj[i])
    x_traj[i+1] = x_traj[i] + dt * dx
    y_traj[i+1] = y_traj[i] + dt * dy

  return (x_traj, y_traj)

# for vector field
v = np.linspace(-2, 2, 27)
w = np.linspace(-1, 3, 27)
V, W = np.meshgrid(v, w)

# Compute vector field
dV, dW = FHmodel(V, W)

# Lengte 1
mag = np.sqrt(dV**2 + dW**2)
dV_norm = dV / (mag + 1e-8)  # rare truc voor voorkomen div/0
dW_norm = dW / (mag + 1e-8)

plt.figure(figsize=(8, 6))
plt.quiver(V, W, dV_norm, dW_norm, angles='xy', scale_units='xy', scale=10, color=[(128, 0, 50, 100)], width=0.002)

# Nullclines
v_linspace = np.linspace(-2, 2, 400)

plt.plot(v_linspace, v_nullcline(v_linspace), 'r', label='dv/dt = 0 (v-nullcline)')
plt.plot(v_linspace, w_nullcline(v_linspace), 'g', label='dw/dt = 0 (w-nullcline)')

# Trajectery with euler
v_traj, w_traj = Euler(FHmodel, (-1, 1), 100, 0.001)
plt.plot(v_traj, w_traj, 'k-', lw=1.5, label='Trajectory starting (-1, 1)')

# labels enzo
ax = plt.gca()
props = dict(boxstyle='round', facecolor='wheat', alpha=0.5)
text = (
    rf"$a = {a}$" "\n"
    rf"$b = {b}$" "\n"
    rf"$\epsilon = {epsilon}$" "\n"
    rf"$I_{{\mathrm{{ext}}}} = {I_ext}$"
)
ax.text(0.05, 0.95, text, transform=ax.transAxes, fontsize=12,
        verticalalignment='top', bbox=props)

plt.xlabel('v ("membrane potential")')
plt.ylabel('w (recovery)')
plt.title('FitzHugh-Nagumo')
plt.legend()
plt.grid(True)
# plt.show()
plt.savefig('I_ext=0.1.png', bbox_inches='tight')

