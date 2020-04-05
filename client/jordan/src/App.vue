<template>
  <div id="app">
    <nav class="topnav">
      <router-link to="/">Home</router-link>
      <router-link to="/videos">My Streams</router-link>
      <router-link to="/login" v-if="showLogin">Login</router-link>
    </nav>
    <router-view></router-view>
  </div>
</template>

<script>

export default {
  name: 'App',
  data: () => ({
    showLogin: !localStorage.userInfo || !JSON.parse(localStorage.userInfo).token
  })
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  background-color:#E0E5EC;
  padding: 0px 0px;
  width: 100%;
  height: 100vh;
}

#youtubePlayer {
  padding: 0px 20px;
  margin-bottom: 20px;
}

.topnav {
  background-color: #333;
  overflow: hidden;
}

/* Style the links inside the navigation bar */
.topnav a {
  float: left;
  color: #f2f2f2;
  text-align: center;
  padding: 14px 16px;
  text-decoration: none;
  font-size: 17px;
}

/* Change the color of links on hover */
.topnav a:hover {
  background-color: #ddd;
  color: black;
}

/* Add a color to the active/current link */
.topnav a.active {
  background-color: #4CAF50;
  color: white;
}
</style>
