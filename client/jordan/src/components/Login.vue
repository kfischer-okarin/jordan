<template>
  <div class="login-panel neomorph">
    <h1>Jordan</h1>
    <p>... the church streaming solution</p>
    <div>
      <div class="neomorph" id="login-button">
      <g-signin-button
        :params="googleSignInParams"
        @success="onSignInSuccess"
        @error="onSignInError">
        Sign in with Google
      </g-signin-button>
      </div>
    </div>
  </div>
</template>

<script>
  import mine from '../mine';

  export default {
    name: 'Login',
    data: () => ({
      googleSignInParams: {
        client_id: '885853592856-u071tv2c2bpbcs5gqn12mc4vs0kcavif.apps.googleusercontent.com'
      }
    }),
    methods: {
      onSignInSuccess (googleUser) {
        // `googleUser` is the GoogleUser object that represents the just-signed-in user.
        // See https://developers.google.com/identity/sign-in/web/reference#users
        var profile = googleUser.getBasicProfile();
        mine.sendRequestWithoutAuth('/sessions', {'idtoken': googleUser.getAuthResponse().id_token}, 'POST').then((res) => {
          localStorage.userInfo = JSON.stringify({
            "id": profile.getId(),
            "name": profile.getName(),
            "image": profile.getImageUrl(),
            "email": profile.getEmail(),
            "token": res.api_token
          });
          this.$router.push('/videos');
        });
      },
      onSignInError (error) {
        // `error` contains any error occurred.
        console.log('OH NOES', error)
      }
    },
    created() {
     if(localStorage.userInfo && JSON.parse(localStorage.userInfo).token) {
       this.$router.push('/videos');
      }
    }
  }

</script>

<style scoped>

.g-signin-button {
  color: red;
  height: 50px;
  font-size: 1.2em;
  position: relative;
  top: 10px;
}

#login-button {
  margin: 30px auto 0 auto;
  width: 200px;
  cursor: pointer;
}

.login-panel {
  position: relative;
  text-align: center;
  width: 600px;
  padding: 20px;
  top: 30%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.neomorph {
  /* Basic styling and alignment */
  border-radius:4px;
  border: 0;
    /* Basic styling and alignment */
  /* For Neumorphism Effect */
  background-color:#E0E5EC;
  box-shadow: 3px 3px 6px rgb(163,177,198,0.6), -9px -9px 16px    rgba(255,255,255, 0.5);
}
</style>