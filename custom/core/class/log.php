<?php

class Script {
    public function Info() {
        return $GLOBALS['database']->GetContent('logs');
    }
}

class Server {
    public function Info($method) {
        switch($method) {
            case "all": return $GLOBALS['database']->GetContent('backdoors');
            case "public": return $GLOBALS['database']->GetContent('backdoors', ['userkey' => 'none']);
            case "private": return $GLOBALS['database']->GetContent('backdoors', ['userkey' => $_SESSION['token']]);
        }
    }
}

?>