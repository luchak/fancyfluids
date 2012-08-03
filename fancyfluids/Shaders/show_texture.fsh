precision mediump float;

varying mediump vec4 f_texcoord;
uniform sampler2D tex0;

void main() {
    gl_FragColor = texture2D(tex0, f_texcoord.st);
}