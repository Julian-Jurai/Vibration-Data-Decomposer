
## SETUP
require "bigdecimal"
require 'awesome_print'
require 'csv'
require 'pycall/import'
include PyCall::Import
require 'matplotlib/pyplot'

## DATA PATH
def data_paths
  $data_paths ||= (1..4).reduce({}) do |acc, i|
    channel = ['channel',i.to_s].join("_")
    acc[channel] = {}
    ['auto_spectrum', 'overall', 'recorder', 'time_waveform'].each do |filename|
      acc[channel][filename] = "data/" + channel + "/" + filename + '.csv'
    end
    acc
  end
end

def read_from_csv(data_path, line_data__starts_at, xproc: nil, yproc: nil)
  ys = []
  xs = []
  line = 0
  CSV.foreach(data_path) do |row|
    line += 1
    if line < line_data__starts_at
      nil
    else
      x = row[0].to_f
      y = row[1].to_f

      x = xproc.call(x,y) if xproc
      y = yproc.call(x,y) if yproc

      xs.push x
      ys.push y
    end
  end
  [xs,ys]
end

def plot_channel(channel_number, axs)
  path_key = "channel_#{channel_number}"
  title = "Channel #{channel_number}"
  row = channel_number - 1
  axs[row][0].grid(true)
  axs[row][1].grid(true)
  axs[0][0].set_title("Acceleration (g^2/Hz) vs frequency (Hz)")
  axs[0][1].set_title("Acceleration (g) vs time (s)")

  to_g_sqrd_div_hz = Proc.new { |x,y| y }
  channel_auto_spectrum_csv = data_paths[path_key]["auto_spectrum"]
  channel_chart_1 = read_from_csv(channel_auto_spectrum_csv, 22, yproc: to_g_sqrd_div_hz)
  channel_recorder_csv = data_paths[path_key]["recorder"]
  channel_chart_2 = read_from_csv(channel_recorder_csv, 11)

  ## CHART 1
  axs[row][0].plot(*channel_chart_1)
  axs[row][0].set_ylabel(title)

  ## CHART 2
  axs[row][1].plot(*channel_chart_2)
  # axs[row][1].set_xlabel('time')
end

# # CHANNEL 1
# channel_1_auto_spectrum_csv = data_paths["channel_1"]["auto_spectrum"]
# channel_1_chart_1 = read_from_csv(channel_1_auto_spectrum_csv, 22, yproc: to_g_sqrd_div_hz)
# channel_1_recorder_csv = data_paths["channel_1"]["recorder"]
# channel_1_chart_2 = read_from_csv(channel_1_recorder_csv, 11)
# axs[0][0].set_title("Channel 1")
# ## CHART 1
# axs[0][0].plot(*channel_1_chart_1)
# axs[0][0].set_xlabel('Hz')
# axs[0][0].set_ylabel('Acceleration g^2/Hz')

# ## CHART 2
# axs[0][1].plot(*channel_1_chart_2)
# axs[0][1].set_ylabel('Acceleration g')
# axs[0][1].set_xlabel('time')

# CHANNEL 2
# channel_2_auto_spectrum_csv = data_paths["channel_2"]["auto_spectrum"]
# channel_2_chart_1 = read_from_csv(channel_2_auto_spectrum_csv, 22, yproc: to_g_sqrd_div_hz)
# channel_2_recorder_csv = data_paths["channel_2"]["recorder"]
# channel_2_chart_2 = read_from_csv(channel_2_recorder_csv, 11)
# axs[1][0].set_title("Channel 2")
# ## CHART 1
# axs[1][0].plot(*channel_2_chart_1)
# axs[1][0].set_xlabel('Hz')
# axs[1][0].set_ylabel('Acceleration g^2/Hz')

# ## C1ART 2
# axs[1][1].plot(*channel_2_chart_2)
# axs[1][1].set_ylabel('Acceleration g')
# axs[1][1].set_xlabel('time')

# axs[1].plot(xs.map {|v| v -18 }, ys)
# axs[1].set_xlim(0)
# axs[1].axvline(x=15, color: 'red')
# axs[1].axhline(y=2, color: 'orange')
# axs[1].axhline(y=-2, color: 'orange')
# axs[0].set_xlabel('time')
# axs[1].set_xlabel('time')
# axs[0].set_ylabel('vibration')

# axs[0][0].grid(true)
# axs[0][1].grid(true)
# axs[1][0].grid(true)
# axs[1][1].grid(true)


## g^2/hz vs hz
## g^2/hz vs rpm
## g vs s
## rpm vs time

def plot_channels(range)
  plt = Matplotlib::Pyplot
  fig, axs = plt.subplots(range.max, 2)
  fig.suptitle("Channel #{range.min} - #{range.max}")
  range.each { |channel_number| plot_channel(channel_number, axs) }

  plt.show()
end

plot_channels(1..4)

