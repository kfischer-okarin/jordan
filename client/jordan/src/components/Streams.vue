<template>
  <div id="container">
    <div>
      <h2 class="title">Jordan Streaming</h2>
      <ul>
        <div v-for="video in videos" class="list-item">
          <span class="status">{{ video.status }}</span>
          <span class="owner"><i>By: {{ video.owner }}</i></span>
          <a :href="'/stream/' + video.video_id"><li>{{ video.title }}</li></a>
        </div>
      </ul>
    </div>
  </div>
</template>

<script>
  import mine from '../mine';

  export default {
    name: 'Streams',
    data: () => ({
      videos: []
    }),
    mounted() {
      this.getVideos();
    },
    methods: {
      getVideos() {
        mine.getRequestWithoutAuth('/videos').then((res) => {
        for(var i = 0; i < res.length; i++) {
          this.videos.push({
            'video_id': res[i].youtube_id,
            'status': res[i].status,
            'title': res[i].title,
            'owner': res[i].user.name
          });
        }
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

  #container {
    width: 900px;
    margin: 0px auto;
  }

  .list-item {
    height: 30px;
    list-style-type: none;
    border-radius:4px;
    background: rgb(163,177,198,0.3);
    border: 2px;
    margin-bottom: 20px;
    padding: 20px 40px;
    position: relative;
  }

  .status {
    display: black;
    position: absolute;
    font-size: 1em;
    top: 3px;
    left: 5px;
  }

  .owner {
    display: black;
    position: absolute;
    font-size: 1em;
    bottom: 5px;
    right: 5px;
  }

  ul {
    padding: 0;
  }
  li {
    font-size: 1.3em;
  }

.title {
  position: relative;
  margin: 0 auto;
  width: max-content;
}
</style>