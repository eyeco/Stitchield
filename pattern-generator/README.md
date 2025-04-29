# patgen

Pattern generator for embroidered shields and sensor elements using space-filling patterns. 

## Dependencies

- freeglut (v3.0.0) [[Github link]](https://github.com/freeglut/freeglut/releases/tag/v3.0.0)
- glew (v2.1.0) [[Github link]](https://github.com/nigels-com/glew/releases/tag/glew-2.1.0) OpenGL extension wrangler library
- glm (v0.9.9.3) [[Github link]](https://github.com/g-truc/glm/releases/tag/0.9.9.3) OpenGL Mathematics header library
- DearImGui (v1.68) GUI library is for now included [directly](./src/imgui/) in the source-code and built along the project (as [suggested](https://github.com/ocornut/imgui/wiki/Getting-Started#compilinglinking) in the ImGui Wiki). [[Github link]](https://github.com/ocornut/imgui/releases/tag/v1.68)

## Todo:

- implement Inch unit for SVG export
- removed Shared Items Project and put shared code into static library
- remove ImGui from source folder, compile into static library
- port to gcc ad provide CMake files

## Credits

Developed by [Roland Aigner](https://www.rolandaigner.com/). Parts of this code were developed at the [Upper Austria University of Applied Sciences](https://fh-ooe.at/campus-hagenberg/), througout the project [TextileUX – Imperceptible Textile Interfaces](https://mi-lab.org/textileux/), (project no. 865791) which is part of the FFG handled COMET program, funded by BMVIT, BMDW, and the State of Upper Austria.

## License

Copyright (C) 2025 eyeco

Licensed under the GPL3 License, see [LICENSE](../LICENSE) for more information.
