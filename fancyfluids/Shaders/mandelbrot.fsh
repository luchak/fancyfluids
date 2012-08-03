precision mediump float;

varying mediump vec4 f_texcoord;

vec2 julia_iter(vec2 z, vec2 c) {
    return vec2(z.x*z.x - z.y*z.y, dot(z.xy, z.yx)) + c;
}

void main() {
    float max_iters = 40.0;
    vec2 z = f_texcoord.st*vec2(4.0,3.0) - vec2(2.0,1.5);
    vec2 c = z;
    float i;
    for (i = 0.0; i < max_iters; i += 1.0) {
      z = julia_iter(z, c);
      if (dot(z,z) > 4.0) {
        break;
      }
    }
    float x = i >= max_iters ? 0.0 : 4.0 * (0.5 - abs(i / 100.0 - 0.5));
    gl_FragColor = vec4(x*2.0, (1.0 + x)*x*x*0.8, x*x*x, 1.0);
}
