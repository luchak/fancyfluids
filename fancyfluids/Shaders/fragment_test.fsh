varying mediump vec4 f_texcoord;

void main() {
    gl_FragColor = vec4(f_texcoord.st, 0.0, 1.0);
}