# FEMM scripts

To support the theoretical background in the paper by Finite Element Methods simulation, the tool of choice was [FEMM](https://www.femm.info/), which (arguably) has a somewhat awkward user interface. The LUA scripts contained in this folder serve as templates to automatically generate the scenes, simulations, and plots used for the main paper based on customizable input parameters, instead of having to do everything manually over and over again, hence, saving considerable effort.

## IABC universe boundary

For simulation boundary, have to define size of the universe; common rule of thumb is 5x the size of the problem you're solving.

## Color palette

To change color palette in FEMM, generate color lists using the [Jupyter](https://jupyter.org/) notebook [colors.ipynb](./colors.ipynb), and place them in the belaview.cfg file of FEMM (make a backup copy first), usually found in the bin folder of your FEMM installation. Replace entries `<Color00>` thru `<Color19>`. An example file specifying the *vidris* color palette is [found in this directory](./belaview.cfg).

## License

Copyright (C) 2025 eyeco

Licensed under the GPL3 License, see [LICENSE](../LICENSE) for more information.