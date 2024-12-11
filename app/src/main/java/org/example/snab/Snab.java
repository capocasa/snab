package org.example.snab;
import org.libsdl.app.SDLActivity;
public class Snab extends SDLActivity {
    @Override
    protected String[] getLibraries() {
        return new String[] {
            "SDL2",
            // "SDL2_image",
            // "SDL2_mixer",
            // "SDL2_net",
            // "SDL2_ttf",
            "snab"
        };
    }
    //protected String getMainFunction() {
    //    return "SDL_main";
    //}
}

