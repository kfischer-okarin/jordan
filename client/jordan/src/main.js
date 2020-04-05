import Vue from 'vue';
import App from './App.vue';
import VueYoutube from 'vue-youtube';
import Editor from './components/Editor.vue';
import VueRouter from 'vue-router';
import GSignInButton from 'vue-google-signin-button';

import routes from './routes';

Vue.config.productionTip = false;
Vue.use(VueYoutube);
Vue.use(VueRouter);
Vue.use(GSignInButton)

const router = new VueRouter({
  mode: 'history',
  routes: routes
});

window.vm = new Vue({
  render: h => h(App),
  router
});
vm.$mount('#app');
