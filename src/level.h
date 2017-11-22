#ifndef LEVEL_H_INCLUDED
#define LEVEL_H_INCLUDED

#include <string>
#include <vector>
#include <utility>

#include <glm/vec2.hpp>
#include <glm/vec3.hpp>
#include <glm/mat4x4.hpp>

#include "shader.h"

namespace world {

// Encapsulates a world
class Level {
    // The number of slices in one direction for a tile
    static constexpr unsigned slices_per_tile = 16;

public:
    // Load the level from the JSON file given by `filename'.
    Level(std::string filename);
    void load_from_file(std::string filename);
    void generate_mesh();

    void render(const glm::mat4& modelview) const;

    auto size() const { return std::make_pair(width, depth); }
    float altitude(float x, float y);

private:
    unsigned width;
    unsigned depth;
    std::vector<float> heightmap;

    struct vertexData {
        glm::vec3 position;
        glm::vec3 normal;
        glm::vec2 texcoord;
    };
    std::vector<vertexData> data;
    std::vector<unsigned short> indices;

    unsigned vbos[2];
    unsigned vaos[1];
    graphics::Shader shader;
    void generate_VBOs();
};

}

#endif
