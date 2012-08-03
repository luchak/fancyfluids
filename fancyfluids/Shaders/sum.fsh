precision mediump float;

varying mediump vec4 f_texcoord;

void main() {
    gl_FragColor = vec4(f_texcoord.st, f_texcoord.s + f_texcoord.t, 1.0);
}