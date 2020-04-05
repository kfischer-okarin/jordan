<template>
  <div id="container">
    <h2 class="title">Jordan Streaming</h2><br>
    <h4> Hello {{ userInfo.name }}</h4><br>
    <form id="add-form" @submit="checkForm">
      <p v-if="errors.length">
        <b>Please correct the following error(s):</b>
        <ul>
          <li  class="list-item error-list" v-for="error in errors">{{ error }}</li>
        </ul>
      </p>
      <input class="textbox neomorph" type="text" v-model="title" id="video_title" placeholder="Stream Title">
      <input class="textbox neomorph" type="text" id="video_id" v-model="videoId" placeholder="Youtube Video Id">
      <button id="add" class="neomorph" @click="checkForm">Add Video</button>
    </form>
    <div>
      <ul>
        <a v-for="video in videos" :href="'/editor/' + video.video_id"><li class="list-item">{{ video.title }}</li></a>
      </ul>
    </div>
  </div>
</template>

<script>
  import mine from '../mine';

  export default {
    name: 'Videos',
    created() {
        if(!localStorage.userInfo || !JSON.parse(localStorage.userInfo).token) {
          this.$router.push('/login');
        }
    },
    data: () => ({
      userInfo: JSON.parse(localStorage.userInfo),
      errors: [],
      title: '',
      videoId: '',
      videos: []
    }),
    mounted() {
      this.getVideos();
    },
    methods: {
      checkForm: function (e) {
        e.preventDefault();
        this.errors = [];
        if (!this.title) {
          this.errors.push('Stream Title is required');
        }
        if (!this.videoId) {
          this.errors.push('Youtube Video ID is required');
        }
        if (this.title && this.videoId) {
          this.addVideo(this.title, this.videoId);
        }
      },
      getVideos() {
        console.log('now getting');
        mine.getRequestWithAuth('/videos').then((res) => {
        for(var i = 0; i < res.length; i++) {
          this.videos.push({
            'video_id': res[i].youtube_id,
            'status': res[i].status,
            'title': res[i].title
          });
        }
      });
      },
      addVideo(ttl, ytId){
        mine.sendRequestWithAuth('/videos/' + ytId, {"title": ttl}, 'PUT').then((res) => {
          console.log(res);
          this.getVideos();
        }).catch((error) => {
          console.error('Error:', error);
        });
      }
    }
  }

</script>

<style scoped>
  .neomorph {
    /* Basic styling and alignment */
    border-radius:4px;
    border: 0;
      /* Basic styling and alignment */
    /* For Neumorphism Effect */
    background-color:#E0E5EC;
    box-shadow: 3px 3px 6px rgb(163,177,198,0.6), -9px -9px 16px    rgba(255,255,255, 0.5);
  }

  .textbox {
    padding: 0 10px;
    height: 50px;
    width: 700px;
    position: relative;
    outline: none;
    background-color: white;
    font-size: 16px;
    margin-bottom: 10px;
  }

  #container {
    width: 900px;
    margin: 0px auto;
  }

  #add {
    height: 30px;
    width: 150px;
    margin-left: 10px;
    cursor: pointer;
  }

  .list-item {
    height: 30px;
    list-style-type: none;
    border-radius:4px;
    background: rgb(163,177,198,0.3);
    border: 2px;
    margin-bottom: 20px;
    padding: 10px 20px;
    font-size: 1.5em;
  }

  .error-list {
    color: red;
    height: 20px;
    font-size: 1em;
  }

  ul {
    padding: 0;
  }

.title {
  position: relative;
  margin: 0 auto;
  width: max-content;
}
</style>