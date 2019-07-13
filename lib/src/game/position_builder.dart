part of game;

class PositionBuilder{

    final GameDependency dependencies;

    PositionBuilder(this.dependencies);

    Position build(String string){
        Position position = dependencies.getPosition();

        position.setVariables(string);

        return position;
    }


}