from bluesky.callbacks import LiveFitPlot, LivePlot, LiveScatter, LiveGrid

def create_jupyter_live_plot(plot_cls):
    import matplotlib.pyplot as plt
    from IPython.display import display, clear_output

    class __JupyterLivePlot(plot_cls):
        def __init__(self, *args, fig=None, ax=None, **kwargs):
            if fig is None:
                fig, ax = plt.subplots()
            super().__init__(*args, ax=ax, **kwargs)
            self._figure = fig
    
        def __call__(self, event_name, event_data, *args, **kwargs):
            super().__call__(event_name, event_data, *args, **kwargs)
            display(self._figure, clear=True)
            if event_name == "stop":
                clear_output(True)
            self._figure.canvas.draw()

    return __JupyterLivePlot

JupyterLivePlot = create_jupyter_live_plot(LivePlot)
JupyterLiveScatter = create_jupyter_live_plot(LiveScatter)
JupyterLiveFitPlot = create_jupyter_live_plot(LiveFitPlot)
JupyterLiveGrid = create_jupyter_live_plot(LiveGrid)