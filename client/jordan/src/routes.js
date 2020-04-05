import Editor from './components/Editor.vue';
import Login from './components/Login.vue';
import Videos from './components/Videos.vue';
import Stream from './components/Stream.vue';
import Streams from './components/Streams.vue';

const routes = [
    { path: '/', component: Streams },
    { path: '/editor', component: Editor },
    { path: '/editor/:videoId', component: Editor, props: true },
    { path: '/stream/:videoId', component: Stream, props: true },
    { path: '/streams', component: Streams},
    { path: '/login', component: Login },
    { path: '/videos', component: Videos }
];

export default routes;