{pkgs, ...}:
pkgs.nixosTest {
  name = "neo4j-apoc";
  nodes.server = {
    config,
    pkgs,
    ...
  }: {
    services.neo4j = {
      enable = true;
      https.enable = false;
      bolt = {
        enable = true;
        listenAddress = "0.0.0.0:7687";
      };
      extraServerConfig = "dbms.security.auth_enabled=false";
    };
    imports = [../modules/neo4j-apoc.nix];
  };
  testScript = ''
    start_all()
    server.wait_for_unit("neo4j.service")
    server.wait_for_open_port(7687)
    server.succeed("cypher-shell -u neo4j -p neo4j 'RETURN 1' > /dev/null")
    server.succeed("cypher-shell -u neo4j -p neo4j 'CALL apoc.help(\"apoc\")'")
  '';
}
